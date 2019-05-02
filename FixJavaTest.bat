:: Author - Adam Lucero
:: 04/2019
:: Java Remediation Tool
:: If Java is not installed, don't do anything
:: If Java is installed, upgrade, and remove old versions
:: Disable UAC before Running!!!
@ECHO OFF


:: Edit this variable for latest version - It's used elsewhere.
set latestJava=Java 8 Update 201

set complete=Yes
set completex=Yes

::
:: JRE CHECKS
::

:: Check for newest version
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO PASS - NEW JAVA CHECK ---
   GOTO :eof
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO PASS - NEW JAVA CHECK 2 ---
   GOTO :eof
)

:: If Java is not installed skip the entire script
DIR "C:\Program Files\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO File Path JRE---
    SET complete=No
    SET jreFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO File Path JRE 2---
    SET complete=No
    SET jreFiles=Yes
)
DIR "C:\Program Files\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO File Path JDK---
    SET complete=No
    SET jdkFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO File Path JDK 2---
    SET complete=No
    SET jdkFiles=Yes
)
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (
   ECHO PASS - JAVA CHECK ---
   SET completex=No
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (
   ECHO PASS - JAVA CHECK 2 ---
   SET completex=No
) 

:: Java 8 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 8 Family...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 8 Family 2...
   set updateFlag=Yes
)
:: Java 7 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 7 Family...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 7 Family 2...
   set updateFlag=Yes
)
:: Java 6 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 6 Family...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 6 Family 2...
   set updateFlag=Yes
)
:: JDK Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK Family...
   set jdkFound=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK Family 2...
   set ujdkFound=Yes
)


::
:: JRE ACTION
::

:: Use this to quit everything if Java is not found above
IF "%complete%"=="Yes" (
   IF "%completex%"=="Yes" (
      ECHO FAILED TO FIND JAVA ---
      GOTO :eof
   )
)
:: Then if new Java is installed to this



:: If old JRE detected, install new - CHANGE PATH FOR ***INSTALLATION***
IF "%updateFlag%"=="Yes" (
   ECHO UPGRADING Java ---
)
:: Verify new installation
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO SUCCESSFUL INSTALLATION ---
   SET removeOld=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO SUCCESSFUL INSTALLATION 2 ---
   SET removeOld=Yes
)
:: Remove old if new version successfully installed
IF "%removeOld%"=="Yes" (
   ECHO UNINSTALLING OLD ---
) else (
   ECHO FAILED INSTALL or JDK ONLY
)

:eof