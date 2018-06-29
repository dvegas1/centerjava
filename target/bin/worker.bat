@REM ----------------------------------------------------------------------------
@REM Copyright 2001-2004 The Apache Software Foundation.
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.
@REM ----------------------------------------------------------------------------
@REM

@echo off

set ERROR_CODE=0

:init
@REM Decide how to startup depending on the version of windows

@REM -- Win98ME
if NOT "%OS%"=="Windows_NT" goto Win9xArg

@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" @setlocal

@REM -- 4NT shell
if "%eval[2+2]" == "4" goto 4NTArgs

@REM -- Regular WinNT shell
set CMD_LINE_ARGS=%*
goto WinNTGetScriptDir

@REM The 4NT Shell from jp software
:4NTArgs
set CMD_LINE_ARGS=%$
goto WinNTGetScriptDir

:Win9xArg
@REM Slurp the command line arguments.  This loop allows for an unlimited number
@REM of arguments (up to the command line limit, anyway).
set CMD_LINE_ARGS=
:Win9xApp
if %1a==a goto Win9xGetScriptDir
set CMD_LINE_ARGS=%CMD_LINE_ARGS% %1
shift
goto Win9xApp

:Win9xGetScriptDir
set SAVEDIR=%CD%
%0\
cd %0\..\.. 
set BASEDIR=%CD%
cd %SAVEDIR%
set SAVE_DIR=
goto repoSetup

:WinNTGetScriptDir
set BASEDIR=%~dp0\..

:repoSetup


if "%JAVACMD%"=="" set JAVACMD=java

if "%REPO%"=="" set REPO=%BASEDIR%\repo

set CLASSPATH="%BASEDIR%"\etc;"%REPO%"\com\google\guava\guava\18.0\guava-18.0.jar;"%REPO%"\org\apache\pdfbox\pdfbox\2.0.0\pdfbox-2.0.0.jar;"%REPO%"\org\apache\pdfbox\fontbox\2.0.0\fontbox-2.0.0.jar;"%REPO%"\commons-logging\commons-logging\1.2\commons-logging-1.2.jar;"%REPO%"\org\slf4j\slf4j-api\1.7.12\slf4j-api-1.7.12.jar;"%REPO%"\org\slf4j\slf4j-log4j12\1.7.12\slf4j-log4j12-1.7.12.jar;"%REPO%"\log4j\log4j\1.2.17\log4j-1.2.17.jar;"%REPO%"\junit\junit\4.12\junit-4.12.jar;"%REPO%"\org\hamcrest\hamcrest-core\1.3\hamcrest-core-1.3.jar;"%REPO%"\com\zaxxer\HikariCP\2.7.8\HikariCP-2.7.8.jar;"%REPO%"\org\springframework\spring-beans\5.0.5.RELEASE\spring-beans-5.0.5.RELEASE.jar;"%REPO%"\org\springframework\spring-core\5.0.5.RELEASE\spring-core-5.0.5.RELEASE.jar;"%REPO%"\org\springframework\spring-jcl\5.0.5.RELEASE\spring-jcl-5.0.5.RELEASE.jar;"%REPO%"\org\springframework\boot\spring-boot\2.0.1.RELEASE\spring-boot-2.0.1.RELEASE.jar;"%REPO%"\org\springframework\spring-context\5.0.5.RELEASE\spring-context-5.0.5.RELEASE.jar;"%REPO%"\org\springframework\spring-aop\5.0.5.RELEASE\spring-aop-5.0.5.RELEASE.jar;"%REPO%"\org\springframework\spring-expression\5.0.5.RELEASE\spring-expression-5.0.5.RELEASE.jar;"%REPO%"\org\springframework\boot\spring-boot-autoconfigure\2.0.1.RELEASE\spring-boot-autoconfigure-2.0.1.RELEASE.jar;"%REPO%"\org\springframework\spring-web\5.0.5.RELEASE\spring-web-5.0.5.RELEASE.jar;"%REPO%"\im\bci\tablelayout\0.7\tablelayout-0.7.jar;"%REPO%"\org\springframework\boot\spring-boot-maven-plugin\2.0.3.RELEASE\spring-boot-maven-plugin-2.0.3.RELEASE.jar;"%REPO%"\org\springframework\boot\spring-boot-loader-tools\2.0.3.RELEASE\spring-boot-loader-tools-2.0.3.RELEASE.jar;"%REPO%"\org\apache\commons\commons-compress\1.14\commons-compress-1.14.jar;"%REPO%"\org\apache\maven\maven-archiver\2.6\maven-archiver-2.6.jar;"%REPO%"\org\apache\maven\shared\maven-shared-utils\0.7\maven-shared-utils-0.7.jar;"%REPO%"\com\google\code\findbugs\jsr305\2.0.1\jsr305-2.0.1.jar;"%REPO%"\org\codehaus\plexus\plexus-interpolation\1.21\plexus-interpolation-1.21.jar;"%REPO%"\org\apache\maven\maven-artifact\3.1.1\maven-artifact-3.1.1.jar;"%REPO%"\org\apache\maven\maven-core\3.1.1\maven-core-3.1.1.jar;"%REPO%"\org\apache\maven\maven-settings-builder\3.1.1\maven-settings-builder-3.1.1.jar;"%REPO%"\org\apache\maven\maven-repository-metadata\3.1.1\maven-repository-metadata-3.1.1.jar;"%REPO%"\org\apache\maven\maven-model-builder\3.1.1\maven-model-builder-3.1.1.jar;"%REPO%"\org\apache\maven\maven-aether-provider\3.1.1\maven-aether-provider-3.1.1.jar;"%REPO%"\org\eclipse\aether\aether-spi\0.9.0.M2\aether-spi-0.9.0.M2.jar;"%REPO%"\org\eclipse\aether\aether-impl\0.9.0.M2\aether-impl-0.9.0.M2.jar;"%REPO%"\org\eclipse\aether\aether-api\0.9.0.M2\aether-api-0.9.0.M2.jar;"%REPO%"\org\eclipse\aether\aether-util\0.9.0.M2\aether-util-0.9.0.M2.jar;"%REPO%"\org\eclipse\sisu\org.eclipse.sisu.plexus\0.0.0.M5\org.eclipse.sisu.plexus-0.0.0.M5.jar;"%REPO%"\javax\enterprise\cdi-api\1.0\cdi-api-1.0.jar;"%REPO%"\javax\annotation\jsr250-api\1.0\jsr250-api-1.0.jar;"%REPO%"\javax\inject\javax.inject\1\javax.inject-1.jar;"%REPO%"\org\sonatype\sisu\sisu-guice\3.1.0\sisu-guice-3.1.0-no_aop.jar;"%REPO%"\aopalliance\aopalliance\1.0\aopalliance-1.0.jar;"%REPO%"\org\eclipse\sisu\org.eclipse.sisu.inject\0.0.0.M5\org.eclipse.sisu.inject-0.0.0.M5.jar;"%REPO%"\org\codehaus\plexus\plexus-classworlds\2.5.1\plexus-classworlds-2.5.1.jar;"%REPO%"\org\codehaus\plexus\plexus-component-annotations\1.5.5\plexus-component-annotations-1.5.5.jar;"%REPO%"\org\sonatype\plexus\plexus-sec-dispatcher\1.3\plexus-sec-dispatcher-1.3.jar;"%REPO%"\org\sonatype\plexus\plexus-cipher\1.4\plexus-cipher-1.4.jar;"%REPO%"\org\apache\maven\maven-model\3.1.1\maven-model-3.1.1.jar;"%REPO%"\org\apache\maven\maven-plugin-api\3.1.1\maven-plugin-api-3.1.1.jar;"%REPO%"\org\apache\maven\maven-settings\3.1.1\maven-settings-3.1.1.jar;"%REPO%"\org\apache\maven\shared\maven-common-artifact-filters\1.4\maven-common-artifact-filters-1.4.jar;"%REPO%"\org\apache\maven\maven-project\2.0.8\maven-project-2.0.8.jar;"%REPO%"\org\apache\maven\maven-profile\2.0.8\maven-profile-2.0.8.jar;"%REPO%"\org\apache\maven\maven-artifact-manager\2.0.8\maven-artifact-manager-2.0.8.jar;"%REPO%"\org\apache\maven\wagon\wagon-provider-api\1.0-beta-2\wagon-provider-api-1.0-beta-2.jar;"%REPO%"\org\apache\maven\maven-plugin-registry\2.0.8\maven-plugin-registry-2.0.8.jar;"%REPO%"\org\codehaus\plexus\plexus-container-default\1.5.5\plexus-container-default-1.5.5.jar;"%REPO%"\org\apache\xbean\xbean-reflect\3.4\xbean-reflect-3.4.jar;"%REPO%"\commons-logging\commons-logging-api\1.1\commons-logging-api-1.1.jar;"%REPO%"\com\google\collections\google-collections\1.0\google-collections-1.0.jar;"%REPO%"\org\codehaus\plexus\plexus-archiver\2.8.1\plexus-archiver-2.8.1.jar;"%REPO%"\org\codehaus\plexus\plexus-io\2.3.2\plexus-io-2.3.2.jar;"%REPO%"\org\codehaus\plexus\plexus-utils\3.0.24\plexus-utils-3.0.24.jar;"%REPO%"\org\sonatype\plexus\plexus-build-api\0.0.7\plexus-build-api-0.0.7.jar;"%REPO%"\org\mortbay\jetty\servlet-api\2.5-20081211\servlet-api-2.5-20081211.jar;"%REPO%"\org\example\herokujavasample\1.0-SNAPSHOT\herokujavasample-1.0-SNAPSHOT.jar
set EXTRA_JVM_ARGUMENTS=
goto endInit

@REM Reaching here means variables are defined and arguments have been captured
:endInit

%JAVACMD% %JAVA_OPTS% %EXTRA_JVM_ARGUMENTS% -classpath %CLASSPATH_PREFIX%;%CLASSPATH% -Dapp.name="worker" -Dapp.repo="%REPO%" -Dbasedir="%BASEDIR%" com.example.MAIN %CMD_LINE_ARGS%
if ERRORLEVEL 1 goto error
goto end

:error
if "%OS%"=="Windows_NT" @endlocal
set ERROR_CODE=1

:end
@REM set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" goto endNT

@REM For old DOS remove the set variables from ENV - we assume they were not set
@REM before we started - at least we don't leave any baggage around
set CMD_LINE_ARGS=
goto postExec

:endNT
@endlocal

:postExec

if "%FORCE_EXIT_ON_ERROR%" == "on" (
  if %ERROR_CODE% NEQ 0 exit %ERROR_CODE%
)

exit /B %ERROR_CODE%
