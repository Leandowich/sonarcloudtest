#!/bin/sh

# Fetch all commit history so that SonarQube has exact blame information
# for issue auto-assignment
# This command can fail with "fatal: --unshallow on a complete repository does not make sense"
# if there are not enough commits in the Git repository (even if Travis executed git clone --depth 50).
# For this reason errors are ignored with "|| true"
git fetch --unshallow || true

# Check for different scenarios and react accordingly. This is neccesary 
# because we have instances where we cannot analyze in a meaningful way, or we need to setup
# additional parameters aka github specific commentary
if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
	echo 'Build and analyze release branch'
	mono ./tools/sonar/SonarQube.Scanner.MSBuild.exe begin /n:sonarcloudtest /k:leandowich-github /d:sonar.login=${SONAR_TOKEN} \
		/d:sonar.host.url="https://sonarcloud.io" /d:sonar.cs.vstest.reportsPaths="**/TestResults/*.trx" \ # .NET Core test coverage
		/d:sonar.ts.tslintconfigpath="**/tslint.json" /d:sonar.ts.lcov.reportpath="test-results/coverage/coverage.lcov" \ # Typescript test coverage
		/v:"2.0" 
elif [ "$TRAVIS_PULL_REQUEST" != "false" ] && [ -n "${GITHUB_TOKEN:-}" ]; then
	echo 'Build and analyze internal pull request'
	mono ./tools/sonar/SonarQube.Scanner.MSBuild.exe begin /n:sonarcloudtest /k:leandowich-github /d:sonar.login=${SONAR_TOKEN} \
		/d:sonar.host.url="https://sonarcloud.io" /d:sonar.cs.vstest.reportsPaths="**/TestResults/*.trx" \ # .NET Core test coverage
		/d:sonar.ts.tslintconfigpath="**/tslint.json" /d:sonar.ts.lcov.reportpath="test-results/coverage/coverage.lcov" \ # Typescript test coverage
		/d:sonar.analysis.mode=preview \
		/d:sonar.github.pullRequest=$TRAVIS_PULL_REQUEST \
		/d:sonar.github.repository=$TRAVIS_REPO_SLUG \
		/d:sonar.github.oauth=$GITHUB_TOKEN \
		/d:/v:"2.0"
else
	echo 'Build feature branch or external pull request'
fi
 
dotnet restore
dotnet build
#dotnet test

# dotnet test NGenerics.Tests --logger:trx
# dotnet test NGenerics.Examples --logger:trx

if [ "$TRAVIS_PULL_REQUEST" = "false" ] || {[ "$TRAVIS_PULL_REQUEST" != "false" ] && [ -n "${GITHUB_TOKEN:-}" ]}; then
	mono ./tools/sonar/SonarQube.Scanner.MSBuild.exe end /d:sonar.login=${SONAR_TOKEN}
fi