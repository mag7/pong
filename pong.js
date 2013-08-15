/// <reference path="jquery-2.0.3.js" />

leftPaddle = $();
rightPaddle = $();
ball = $();
var gameScreen = $();
$(document).ready(function () {
    leftPaddle = $(".left");
    rightPaddle = $(".right");
    ball = $(".ball");
    gameScreen = $(".gameScreen");
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
    startBall();
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
function setupInput() {
    $(document).keydown(function (e) {
        switch (e.which) {
            case 40:
                rightPaddle.ySpeed = 5;
                break;
            case 38:
                rightPaddle.ySpeed = -5;
                break;
            case 81:
                leftPaddle.ySpeed = -5;
                break;
            case 65:
                leftPaddle.ySpeed = 5;
                break;
            default:
                break;
        }
    });
    $(document).keyup(function (f) {
        switch (f.which) {
            case 40:
                rightPaddle.ySpeed = 0;
                break;
            case 38:
                rightPaddle.ySpeed = 0;
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
}
function gameLoop() {
    update();
    draw();
    setTimeout(gameLoop, 1000 / 30);
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
        ball.ySpeed *= -1;
    }
    if (ball.left < 0) {
        rightPaddle.score++;
        startBall();
    } else if (ball.left > 490) {
        leftPaddle.score++;
        startBall();
    }
}
   
function handleCollision(ball, paddle) {
    if (ball.top >= paddle.top - ball.height / 2 && ball.top <= paddle.top + paddle.height + ball.height / 2) {
        if (ball.left <= paddle.left + paddle.width && ball.left >= paddle.left) {
            ball.xSpeed *= -1.1;
            ball.ySpeed *= 1.1;
        } else if (ball.left >= paddle.left - ball.width && ball.left < paddle.left) {
            ball.xSpeed *= -1.1;
            ball.ySpeed *= 1.1;
        }
    }
}


function draw() {
    $(".leftscore").html(leftPaddle.score);
    $(".rightscore").html(rightPaddle.score);
    drawGameObject(leftPaddle);
    drawGameObject(rightPaddle);
    drawGameObject(ball);
}

function drawGameObject(obj) {
    obj.css("left", obj.left + "px");
    obj.css("top", obj.top + "px");
}

