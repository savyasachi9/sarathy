<?php

function runningSum($nums) {
    $runningSum = [];
    $len = count($nums);
    $sum = 0;
    for ($i = 0; $i < $len; $i++) {
        $sum += $nums [$i];
        $runningSum[] = $sum;
    }

    return $runningSum;
}

print_r(runningSum([1])) . "\n";
print_r(runningSum([1, 2])) . "\n";
print_r(runningSum([1, 2, 3])) . "\n";

print_r(runningSum([0, 0, 0])) . "\n";