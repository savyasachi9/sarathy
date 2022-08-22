<?php

/**
 * var $s string
 */
function longestSubstringWithoutRepeatingChars($s) {

    $sLen       = strlen($s);
    $maxLen     = 0;
    $maxLenStr  = '';
    $visitedMap = [];

    for ($i = 0; $i < $sLen; $i++) {
        echo "checking if value {$s[$i]} at idx {$i} exists in visited\n";
        if (isset($visitedMap [$s [$i]])) {

        }

    }
}

print_r(longestSubstringWithoutRepeatingChars('abcdefabcxyzlmnabc'));