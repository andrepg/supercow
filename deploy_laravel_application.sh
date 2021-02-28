clear

echo "What is the folder name?" 
read folderName

echo "Checking folder existence"
if [ -d $folderName ]; then
  echo "Removing existent content to clone again"
  rm -fr "$folderName/*"
fi

echo "What is the repository name? "
echo "Use GitHub Cli format ( owner/repo_name )"
echo " -- if the owner part was ommited it would be used the current user as owner"
echo " -- to learn more visit https://github.com/cli/cli"
read repoName

echo "Cloning $repoName repository"
gh repo clone $repoName $folderName && cd $folderName

echo "Installing composer and npm dependencies"
composer install && npm install

echo "Cleaning and optimizing application"
php artisan clear-compiled
php artisan optimize:clear
php artisan optimize

echo "Compiling npm assets and production"
npm run production

echo "We will do a rsync deploy? [ Y / N ]" 
read doDeploy

if [[ $doDeploy == "Y" ]]; then

  echo "What is the remote path to our deploy?" 
  read remotePath

  echo "Starting RSync deploy"
  
  # For more information visit https://explainshell.com/explain?cmd=rsync+-arzu+--human-readable+.%2Fpath%2F*+remotehost%3A%2Fremote%2Fpath
  
  rsync -arzu \
    --human-readable \
    --exclude '.env.example' \
    --exclude '.codeclimate.yml'
    --exclude 'docker-compose.yml' \
    --exclude '.styleci.yml' \
    --exclude '.editorconfig' \
    --exclude '*.code-workspace' \
    --exclude '.idea' \
    --exclude '.env.*' \
    --exclude '.git' \
    --exclude '.gitattributes' \
    --exclude '.github' \
    --exclude '.gitignore' \
    --exlude '.phpunit.*' \
    --exclude '*.sqlite' \
    --exclude '*.json' \
    --exclude '*.lock' \
    --exclude 'tests' \
    --exclude 'phpunit.xml' \
    --exclude 'node_modules' \
    --exclude 'webpack.mix.js' \
    ./* \
    $remotePath
    
fi
