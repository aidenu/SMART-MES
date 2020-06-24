$(function(){
		blinkOn_Orange();
		blinkOn_Gray();
		blinkOn_Yellow();
		blinkOn_Green();
		blinkOn_Red();
	}
)
 
function blinkOn_Orange(){
    $(".blink_orange").css("background-color", "#FFB56A");
    $(".blink_orange").css("height", "100%");
    setTimeout("blinkOff_Orange()", 1000);
}
 
function blinkOff_Orange(){
    $(".blink_orange").css("background-color", "white");
    $(".blink_orange").css("height", "100%");
    setTimeout("blinkOn_Orange()", 1000);
}

function blinkOn_Gray(){
    $(".blink_gray").css("background-color", "#EFEFEF");
    setTimeout("blinkOff_Gray()", 1000);
}
 
function blinkOff_Gray(){
    $(".blink_gray").css("background-color", "white");
    setTimeout("blinkOn_Gray()", 1000);
}

function blinkOn_Yellow(){
    $(".blink_yellow").css("background-color", "#FFFF97");
    setTimeout("blinkOff_Yellow()", 1000);
}
 
function blinkOff_Yellow(){
    $(".blink_yellow").css("background-color", "white");
    setTimeout("blinkOn_Yellow()", 1000);
}

function blinkOn_Green(){
    $(".blink_green").css("background-color", "#006400");
    setTimeout("blinkOff_Green()", 1000);
}
 
function blinkOff_Green(){
    $(".blink_green").css("background-color", "white");
    setTimeout("blinkOn_Green()", 1000);
}

function blinkOn_Red(){
    $(".blink_red").css("background-color", "#FF0000");
    setTimeout("blinkOff_Red()", 1000);
}
 
function blinkOff_Red(){
    $(".blink_red").css("background-color", "white");
    setTimeout("blinkOn_Red()", 1000);
}