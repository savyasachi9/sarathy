<?php

function isIsomorphic($s, $t) {
    $len = strlen($s);
    $m1  = [];
    $m2  = [];

    // set first val of string s/t into map m1/m2
    $m1 [$s[0]] = 0;
    $m2 [$t[0]] = 0;

    for ($i = 0; $i < $len; $i++) {
        if ($m1 [$s[$i]] != $m2 [$t[$i]]) {
            return false;
        }

        // set inner values of string into map if keys don't exists
        // > 0 && < n - 1
        $j = $i + 1;
        if ($j < $len) {
            if (!isset($m1 [$s[$j]])) {
                $m1 [$s[$j]] = $j;
            }

            if (!isset($m2 [$t[$j]])) {
                $m2 [$t[$j]] = $j;
            }

        }
    }

    return true;
}


var_dump(isIsomorphic('abc', 'xyz'));
var_dump(isIsomorphic('hamara', 'bajaja'));
//var_dump(isIsomorphic('egg', 'add'));
var_dump(isIsomorphic('foo', 'bar'));
var_dump(isIsomorphic('paper', 'title'));