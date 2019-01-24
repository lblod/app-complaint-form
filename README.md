# Complaint form

This application allows citizens to complain via a form.

## What's included?

This repository harvest two setups.  The base of these setups resides in the standard docker-compose.yml.

* *docker-compose.yml* This provides you with the backend components.
* *docker-compose.dev.yml* Provides changes for a good frontend development setup.
  - publishes the backend services on port 80 directly, so you can run `ember serve --proxy http://localhost` when developing the frontend apps natively.
  - publishes the database instance on port 8890 so you can easily see what content is stored in the base triplestore.

## Running and maintaining

  General information on running and maintaining an installation

### Running your setup

#### Running the regular setup

  ```
  docker-compose up
  ```

  The stack is built starting from [mu-project](https://github.com/mu-semtech/mu-project).


#### Running the dev setup

  First install git-lfs (see <https://github.com/git-lfs/git-lfs/wiki/Installation>)

  Execute the following:

      # Make sure git-lfs is enabled after installation
      git lfs install

      # Clone this repository
      git clone https://github.com/lblod/app-complaint-form.git

      # Move into the directory
      cd app-complaint-form

      # Start the system
      docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

  Wait for everything to boot to ensure clean caches.  You may choose to monitor the migrations service in a separate terminal to and wait for the overview of all migrations to appear: `docker-compose logs -f --tail=100 migrations`.

  Once the migrations have ran, you can start developing your application by connecting the ember frontend application to this backend.  See <https://github.com/lblod/frontend-complaint-form> for more information on development with the ember application.

#### Generating a user and password to access files

  In order to use the basic authentication to protect your uploaded files, you will need to generate a username and a password.

  ```
  htpasswd -c ./config/basic-auth/.htpasswd username
  ```

### Upgrading your setup

  Once installed, you may desire to upgrade your current setup to follow development of the main stack.  The following example describes how to do this easily for both the demo setup, as well as for the dev setup.

#### Upgrading the dev setup

  For the dev setup, we assume you'll pull more often and thus will most likely clear the database separately:

      # Bring the application down
      docker-compose -f docker-compose.yml -f docker-compose.dev.yml down
      # Pull in the changes
      git pull origin master
      # Launch the stack
      docker-compose -f docker-compose.yml -f docker-compose.demo.yml up

  As with the initial setup, we wait for everything to boot to ensure clean caches.  You may choose to monitor the migrations service in a separate terminal to and wait for the overview of all migrations to appear: `docker-compose logs -f --tail=100 migrations`.

  Once the migrations have ran, you can go on with your current setup.

### Cleaning the database

  At some times you may want te clean the database and make sure it's in a pristine state.

      # Bring down our current setup
      docker-compose -f docker-compose.yml -f docker-compose.dev.yml down
      # Keep only required database files
      rm -Rf data/db
      git checkout data/db
      # Bring the stack back up
      docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

  Make sure to wait for the migrations to run.
