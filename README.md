skill-hunt
==========

[ ![Codeship Status for BoTreeConsultingTeam/skill-hunt](https://www.codeship.io/projects/1f346cc0-f095-0131-06f7-4eb19103006a/status)](https://www.codeship.io/projects/27437)

Application Setup:

Version:
 
	Rails : 4.1.1
	Ruby  : 2.1.2

Steps:

1. Clone the application in your local directory using
	git clone https://github.com/BoTreeConsultingTeam/skill-hunt.git
   
2. Go to Project Directory and install Appliaction Specific Gems
	bundle install

3. Replace following Placeholders of /config/database.yml.postgresql.template file with your database specifications.
	<POSTGRESQL_USER_NAME>
	<POSTGRESQL_USER_PASSWORD>
	<POSTGRESQL_HOST>
	
4. Rename the /config/database.yml.postgresql.template to database.yml

5. Create Database, load Schema and Initialize with seed data
	rake db:setup

6. Verify Application Rspec-Suite
	rspec
	