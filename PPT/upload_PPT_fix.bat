@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM  最终修复版：移除所有特殊符号 (> 和 括号)
REM ==========================================

REM 1. 切换目录
cd /d "F:\ampa_migra\D\course\Study\博一\水污染技术原理与应用\PPT_OF_WA_PRPTECT"
echo Work Dir: %cd%
echo --------------------------------

REM 2. 初始化 LFS
git lfs install
echo.

REM 3. 开始遍历
echo Scanning files...
echo --------------------------------

for /r "%cd%\PPT" %%F in (*.pptx *.pdf) do (
    set "size=%%~zF"
    if "!size!"=="" set size=0
    
    REM 注意：这里去掉了括号和大于号，防止报错
    echo File: %%~nxF -- Size: !size! bytes

    REM 大于 100MB (104857600 字节)
    if !size! GTR 104857600 (
        echo     [Big File] Tracking with LFS...
        git lfs track "PPT/%%~nxF"
        git add "%%F"
    )

    REM 小于等于 100MB
    if !size! LEQ 104857600 (
        echo     [Small File] Adding normally...
        git add "%%F"
    )
    
    echo --------------------------------
)

echo.
echo Scan finished. Committing...
pause

git commit -m "Auto upload PPTs"
git push origin main

echo.
echo ==========================================
echo                DONE
echo ==========================================
pause
