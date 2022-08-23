<?php

function pivotIndex($nums) {
    $lSum = 0;
    $tSum = array_sum($nums);
    $rSum = $tSum;
    $len  = count($nums);

    for ($i = 0; $i < $len; $i++) {
        // set pivot
        $pivot = $i;

        // calculate rSum (tSum - nums[i])
        $rSum -= $nums [$i];
        echo "lSum($lSum) rSum($rSum) pivot($pivot)\n";

        if ($lSum === $rSum) {
            return $pivot;
        }

        // calculate lSum
        $lSum += $nums [$i];
    }

    return -1;
}

echo pivotIndex([1]) . PHP_EOL;
echo pivotIndex([1, 0]) . PHP_EOL;
echo pivotIndex([1, -1, 1]) . PHP_EOL;
echo pivotIndex([-1, -1, -1, 0, 1, 1]) . PHP_EOL;
echo pivotIndex([1, 0, 1]) . PHP_EOL;
echo pivotIndex([1, 0, 1, 0, 0, 0]) . PHP_EOL;
echo pivotIndex([1, 7, 3, 6, 5, 6]) . PHP_EOL;