/// <reference path="jquery-2.0.3.js" />

leftPaddle = $();
rightPaddle = $();
ball = $();
var gameScreen = $();
var sounds = {
    score: null,
    wallbounce: null,
    paddlebounce: null
}
serve = $();
pause = $();
var paused = false;
var startTurn = false;
//var computerPlayer = (Session["player2ID"] == 0);
var url = window.location.href;
var speed = parseInt(url[url.length - 1]);
    
$(document).ready(function () {
    leftPaddle = $(".left");
    rightPaddle = $(".right");
    ball = $(".ball");
    gameScreen = $(".gameScreen");
    serve = $(".serve");
    pause = $(".pause");
    sounds.score = $(".scoresound")[0];
    sounds.wallbounce = $(".wallsound")[0];
    sounds.paddlebounce = $(".paddlesound")[0];
    setupInput();
    startGame();
});

function initializeGameObject(obj) {
    obj.left = parseInt(obj.css("left"));
    obj.top = parseInt(obj.css("top"));
    obj.xSpeed = 0;
    obj.ySpeed = 0;
    obj.height = parseInt(obj.css("height"));
    obj.width = parseInt(obj.css("width"));
}
function startGame() {
    leftPaddle.css("left", "10px");
    leftPaddle.css("top", "225px");
    rightPaddle.css("left", "480px");
    rightPaddle.css("top", "225px");
    initializeGameObject(leftPaddle);
    initializeGameObject(rightPaddle);
    leftPaddle.score = leftPaddle.score || 0;
    rightPaddle.score = rightPaddle.score || 0;
    startTurn = true;
    pause.hide();
    gameLoop();
}

function startBall() {
    ball.css("left", "245px");
    ball.css("top", "245px");
    initializeGameObject(ball);
    if (Math.random() < 0.5) {
        ball.ySpeed = Math.random() / 2 * -3;
    }
    else {
        ball.ySpeed = Math.random() / 2 * 3;
    }
    if (Math.random() < 0.5) {
        ball.xSpeed = (.5 + (Math.random() / 2)) * -3;
    }
    else {
        ball.xSpeed = (.5 + (Math.random() / 2)) * 3;
    }
}

function computerTracking(ball, rightPaddle) {
    if (ball.top + (ball.height/2) < rightPaddle.top + (rightPaddle.height / 2)) {
        rightPaddle.ySpeed = speed*-1;
    }
    else if (ball.top + (ball.height/2) > rightPaddle.top + (rightPaddle.height / 2)) {
        rightPaddle.ySpeed = speed;
    }
    else {
        rightPaddle.ySpeed = 0;
    }
}

function setupInput() {
    $(document).keydown(function (e) {
        switch (e.which) {
            case 40:
                if (speed === 0) {
                    rightPaddle.ySpeed = rightPaddle.ySpeed || 5;
                }
                break;
            case 38:
                if (speed === 0) {
                    rightPaddle.ySpeed = rightPaddle.ySpeed || -5;
                }
                break;
            case 81:
                leftPaddle.ySpeed = leftPaddle.ySpeed || - 5;
                break;
            case 65:
                leftPaddle.ySpeed = leftPaddle.ySpeed || 5;
                break;
            default:
                break;
        }
    });
    $(document).keyup(function (f) {
        switch (f.which) {
            case 40:
                if (speed === 0) {
                    rightPaddle.ySpeed = 0;
                }
                break;
            case 38:
                if (speed === 0) {
                    rightPaddle.ySpeed = 0;
                }
                break;
            case 81:
                leftPaddle.ySpeed = 0;
                break;
            case 65:
                leftPaddle.ySpeed = 0;
                break;
            default:
                break;
        }
    });
    serve.click(function (e) {
        if (startTurn) {
            startBall();
            startTurn = false;
            paused = false;
            gameLoop();
            pauseServeToggle();
        }
    });
    pause.click(function (e) {
        if (!startTurn) {
            if (paused) {
                paused = false;
                gameLoop();
            }
            else {
                paused = true;
            }
        }
    });


}

function pauseServeToggle() {
    serve.toggle();
    pause.toggle();
}

function gameLoop() {
    update();
    draw();
    if (!paused) {
        setTimeout(gameLoop, 1000 / 30);
    }
}

function update() {
    checkPaddleBoundaries(leftPaddle, rightPaddle);
    leftPaddle.top += leftPaddle.ySpeed;
    rightPaddle.top += rightPaddle.ySpeed;
    checkBallBoundaries(ball);
    if (ball.xSpeed < 0) {
        handleCollision(ball, leftPaddle);
    } else {
        handleCollision(ball, rightPaddle);
    }
    ball.top += ball.ySpeed;
    ball.left += ball.xSpeed;
    leftPaddle.ySpeed *= 1.05;
    if (speed > 0) {
        computerTracking(ball, rightPaddle);
    }
    else {
        rightPaddle.ySpeed *= 1.05;
    }
}

function checkPaddleBoundaries() {
    for (var index = 0; index < arguments.length; index++) {
        if (arguments[index].top <= 0 && arguments[index].ySpeed < 0) {
            arguments[index].ySpeed = 0;
        } else if(arguments[index].top >= 450 && arguments[index].ySpeed > 0) {
            arguments[index].ySpeed = 0;
        }            
    }
}

function checkBallBoundaries(ball) {
    if (ball.top <= 0 || ball.top >= 490) {
        sounds.wallbounce.play();
        ball.ySpeed *= -1;
    }
    if (ball.left < 0) {
        if (++rightPaddle.score == 5) {
            sounds.score.play();
            paused = true;
            window.location.href = "/pong/Victory?player1Score=" + leftPaddle.score + "&player2Score=" + rightPaddle.score;
        }
        else {
            sounds.score.play();
            startTurn = true;
            paused = true;
            startBall();
            pauseServeToggle();
        }
    } else if (ball.left > 490) {
        if (++leftPaddle.score == 5) {
            sounds.score.play();
            paused = true;
            window.location.href = "/pong/Victory?player1Score=" + leftPaddle.score + "&player2Score=" + rightPaddle.score;
        }
        else {
            sounds.score.play();
            startTurn = true;
            paused = true;
            startBall();
            pauseServeToggle();
        }
    }
}
   
function handleCollision(ball, paddle) {
    if (ball.top >= paddle.top - ball.height / 2 && ball.top <= paddle.top + paddle.height + ball.height / 2) {
        if (ball.left <= paddle.left + paddle.width && ball.left >= paddle.left) {
            sounds.paddlebounce.play();
            ball.xSpeed *= -1.1;
            ball.ySpeed = (ball.ySpeed * 1.1) + (paddle.ySpeed / 6);
        } else if (ball.left >= paddle.left - ball.width && ball.left < paddle.left) {
            sounds.paddlebounce.play();
            ball.xSpeed *= -1.1;
            ball.ySpeed = (ball.ySpeed * 1.1) + (paddle.ySpeed / 6);
        }
    }
}


function draw() {
    $(".leftscore").html(leftPaddle.score);
    $(".rightscore").html(rightPaddle.score);
    if (paused) {
        pause.html("Continue");
    }
    else {
        pause.html("Pause");
    }
    drawGameObject(leftPaddle);
    drawGameObject(rightPaddle);
    drawGameObject(ball);
}

function drawGameObject(obj) {
    obj.css("left", obj.left + "px");
    obj.css("top", obj.top + "px");
}

