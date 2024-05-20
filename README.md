# Tatan Store

is a Store app created with Ruby on Rails and Postgres database

## Ruby version

3.2.0

## Setup
```terminal
cd ./tatan_store
bundle install
cp .env.example .env
```
And add your environment variables

## Database creation
run:
```terminal
rails db:create
rails db:migrate
rails db:seed
```
To create mock products run from Rails terminal:
```
FactoryBot.create_list(:product, 100)
```
## How to run the app
```terminal
rails s
```

## How to run the test suite
```terminal
rspec spec
```

## Deployment instructions
These instructions are to be defined

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

