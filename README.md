# TopPop

## Overview 

TopPop is a music video sorting game. To win this game, you have to accurately sort a number of *top pop*ular music videos in order of their popularity.

TopPop source code contains the web application repo (this repo) and [the web api repo](https://github.com/PigeonBiz/TopPop-api).

<!-- The application is live here: [https://toppop.herokuapp.com](https://toppop.herokuapp.com). -->

## How to play

<!-- Please use the Chrome browser to open [the TopPop website](https://toppop.herokuapp.com) because some videos couldn't be displayed in other browsers.

The application is running under Heroku free tier, so it will take some time to wake up. Please be patient! -->

You need to input a username. 

You will be given 5 music videos to sort from most views to least views. 20 points will be given for a correct ranking. You can view the videos while sorting. You can play as long as you wish.

After submitting the rankings, you will receive your score. This score is stored on the browser's cookie and could be found on the Game records. You can play again as many times as you wish. You can view the correct rankings and view counts.


## Instructions 

Instructions to run the TopPop web app on local environment

### 1. Install

Clone the repo:
```bash
git clone https://github.com/PigeonBiz/TopPop-APP
cd TopPop-APP
```
Install all gems in Gemfile:
```bash
bundle install
```

### 2. Input variables in `config/secrets.yml`

Clone `secrets_example.yml`, rename `secrets.yml`.

Generate session key:
```bash
rake new_session_secret
```

Input the session key to `secrets.yml`.

### 3. Launch the web app on local environment (in development mode)

Run:
```bash
RACK_ENV=development rake run:dev
```

You should see the web app live on port 9000 `http://localhost:9000`.

### 4. Launch the api app on local evironment (in development mode)

Follow [this instructions](https://github.com/PigeonBiz/TopPop-APi#instructions) to launch the api app. Then add 5 videos to the database.

### 5. Play

You can start playing the game on port 9000 `http://localhost:9000`.


## Contributors

PigeonBiz Team:

- [朱凱翊](https://github.com/s28238385)
- [Tran Le Hai Anh](https://github.com/hannahguppy)
- [邱沛語](https://github.com/astridchiou)

Special thanks for our instructor [Soumya Ray](https://github.com/soumyaray) and the teaching assistants [林天佑](https://github.com/tienyulin) and [劉羽玄](https://github.com/emily1129).
