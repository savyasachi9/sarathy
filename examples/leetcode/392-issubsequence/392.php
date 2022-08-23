<?php

// $s : search/sub string
// $t : target string
function isSubsequence($s, $t) {
    // initial position of indexes
    $sIdx = 0;
    $tIdx = 0;

    // loop over both strings & see if any of s/chars exist in t
    while ($sIdx < strlen($s) && $tIdx < strlen($t)) {

        if ($s [$sIdx] === $t [$tIdx]) {
            $sIdx ++;
        }

        $tIdx ++;
    }

    return $sIdx === strlen($s);
}

var_dump(isSubsequence("leet", "lneat ebt code"));