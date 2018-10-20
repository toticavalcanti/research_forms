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
	<code>docker-compose run --rm app bundle install</code>

To create database and make migrations:<br>
	<code>docker-compose run app --rm bundle exec rake db:create db:migrate</code>

To build and up the API:<br>
	<code>docker-compose up --build</code>

If you already build, use only:<br>
	<code>docker-compose up</code>


