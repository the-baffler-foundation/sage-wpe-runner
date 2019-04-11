#So, you want to test your WPE deployment

These scripts are intended to replicate the environment of a Gitlab runner in charge of building and deploying a Roots Sage v9+ WordPress theme to a WPEngine environment.

I'm deeply indebted to [Toby Schrapel](https://github.com/schrapel), who created the Gitlab before script and deploy script that I picked apart for this repo. 

I was [inspired to create this repo](https://stackoverflow.com/questions/46497115/is-it-possible-to-debug-a-gitlab-ci-build-interactively) because it's not possible to interactively debug a Gitlab CI process, and WPE frequently makes small adjustments to their environment that require corresponding tweaks to a deployment pipeline. Tired of waiting for the Gitlab CI to build every time you need to experiment? You might want to try fire up the docker config here and play around before editing the Gitlab config.

##Requirments
* Docker Desktop, I'm using Community ^2.0
* Inside the Docker containers, we need Composer, [Blade Generate](https://github.com/alwaysblank/blade-generate), and the WP CLI. 
* Yes, Sage calls for Yarn, I get better results using npm inside the Gitlab runner. MySQL 8+ doesn't play nice with the WP CLI, I use 5.7 here.  


##Process

1. Fill in the appropriate blanks in sample.env and rename the file .env.

2. Save the public SSH key you use to push to WPE in a file called `entrypoint.sh` and place an export statement at the top of the file. It's not possible to load an SSH key from an .env file, so we must source it at runtime. entrypoint.sh should look like this:

>export SSH_PRIVATE_KEY='-----BEGIN RSA PRIVATE KEY-----
>Mstb9eX3sSITpvtneySLc7ECrwk5p+nGk5lcTHQxSmd3YLjW0+oDTI26P4M5W0sC
>...
>-----END RSA PRIVATE KEY-----'

3. Start the Docker Compose instance: `docker-compose up` and enter the associated _php shell_ `docker-compose run --rm php bin/bash`

4. Inside the shell, you can run the whole `before_script.sh`, or go through the script line by line. `bin/deploy` will require Github creds unless you want to add your SSH key from the runner in Github as well. When you're happy with the pipeline, `before_script.sh` translates into the `gitlab-ci.yml`. I keep `bin/deploy` under the same location in a live runner. 

5. Translate your deploy sequence from the interactive commands into a runner script for Gitlab. Or, if you're lazy, you could build and push to WPE all from the local machine.
