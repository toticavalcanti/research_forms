# Research Form API

Research Form API is a API project to be acess by Angular front-end application, research-forms-client.

## Getting Started

To get a copy of this project on your local machine, use the command below:<br>
<code>git clone git@github.com:toticavalcanti/research_forms.git</code>

### Prerequisites

You must have docker installed in your machine. 
To instruction to this, access:<br>
	https://docs.docker.com/install/

### Installing
To install the Gems use:<br>
	docker-compose run --rm app bundle install

To create database and make migrations:<br>
	docker-compose run app --rm bundle exec rake db:create db:migrate

To build and up the API:<br>
	docker-compose up --build

If you already build, use only:<br>
	docker-compose up


