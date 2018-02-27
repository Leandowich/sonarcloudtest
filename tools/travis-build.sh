#!/bin/sh

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
	mono ./tools/sonar/SonarQube.Scanner.MSBuild.exe begin /n:sonarcloudtest /k:leandowich-github /d:sonar.login=${SONAR_TOKEN} /d:sonar.host.url="https://sonarcloud.io" /d:sonar.cs.vstest.reportsPaths="**/TestResults/*.trx" /d:sonar.ts.tslintconfigpath="**/tslint.json" /d:sonar.ts.lcov.reportpath="test-results/coverage/coverage.lcov" /v:"2.0"
fi
 
dotnet restore
dotnet build
#dotnet test

# dotnet test NGenerics.Tests --logger:trx
# dotnet test NGenerics.Examples --logger:trx

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
	mono ./tools/sonar/SonarQube.Scanner.MSBuild.exe end /d:sonar.login=${SONAR_TOKEN}
fi