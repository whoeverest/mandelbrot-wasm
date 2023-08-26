;; https://developer.mozilla.org/en-US/docs/WebAssembly/Reference

(module
  (memory $memory 20)

  (func $scaleToRange
    (param $n f64)
    (param $sourceRangeMin f64)
    (param $sourceRangeMax f64)
    (param $targetRangeMin f64)
    (param $targetRangeMax f64)
    
    (result f64)

    (local $percentFromSource f64)

    ;; A = (n - sourceRange.min)
    local.get $n
    local.get $sourceRangeMin
    f64.sub

    ;; B = (sourceRange.max - sourceRange.min)
    local.get $sourceRangeMax
    local.get $sourceRangeMin
    f64.sub

    ;; A / B (division)
    f64.div

    ;; let percentFromSource = A / B
    local.set $percentFromSource

    ;; C = (targetRange.max - targetRange.min)
    local.get $targetRangeMax
    local.get $targetRangeMin
    f64.sub

    ;; D = C * percentFromSource
    local.get $percentFromSource
    f64.mul

    ;; E = targetRange.min + D
    local.get $targetRangeMin
    f64.add
  )

  (func $mandelbrot
    (param $width i32)
    (param $height i32)
    (param $xMin f64)
    (param $xMax f64)
    (param $yMin f64)
    (param $yMax f64)

    (local $bigCounter i32)
    (local $counterMax i32)

    (local $y i32)
    (local $x i32)

    (local $res i32)

    ;; total number of pixels
    local.get $width
    local.get $height
    i32.mul
    local.set $counterMax

    ;; init $bigCounter
    i32.const 0
    local.set $bigCounter

    (loop $bigLoop
      ;; i32.const 100
      ;; i32.store

      ;; let y = Math.floor(i / width);
      ;; no need to floor, though.
      local.get $bigCounter
      local.get $width
      i32.div_u
      local.set $y

      ;; let x = i % width;
      local.get $bigCounter
      local.get $width
      i32.rem_u
      local.set $x

      ;; calculate iterations
      local.get $x
      f64.convert_i32_u
      local.get $y
      f64.convert_i32_u
      local.get $width
      f64.convert_i32_u
      local.get $height
      f64.convert_i32_u
      local.get $xMin
      local.get $xMax
      local.get $yMin
      local.get $yMax
      call $calculateIterations
      local.set $res

      ;; store in memory at offset, multiplied by 4 to account for
      ;; the 32bit integers
      local.get $bigCounter
      i32.const 4
      i32.mul
      local.get $res
      i32.store

      i32.const 1
      local.get $bigCounter
      i32.add
      local.set $bigCounter

      ;; loop or exit
      local.get $bigCounter
      local.get $counterMax
      i32.lt_u
      br_if $bigLoop
    )
  )

  (func $calculateIterations
    (param $px f64)
    (param $py f64)
    (param $width f64)
    (param $height f64)
    (param $xMin f64)
    (param $xMax f64)
    (param $yMin f64)
    (param $yMax f64)

    (result i32)

    (local $scaledX f64)
    (local $scaledY f64)
    (local $x f64)
    (local $y f64)
    (local $iteration i32)
    (local $maxIteration i32)
    (local $xTemp f64)

    ;; let scaledX = scaleToRange(py, 0, width, xMin, xMax);    
    local.get $py
    f64.const 0
    local.get $width
    local.get $xMin
    local.get $xMax
    call $scaleToRange
    local.set $scaledX

    ;; let scaledY = scaleToRange(px, 0, height, yMin, yMax);
    local.get $px
    f64.const 0
    local.get $height
    local.get $yMin
    local.get $yMax
    call $scaleToRange
    local.set $scaledY

    ;; let x = 0;
    ;; let y = 0;
    ;; let iteration = 0;
    ;; let maxIteration = 1000;
    f64.const 0
    local.set $x
    f64.const 0
    local.set $y
    i32.const 0
    local.set $iteration
    i32.const 1000
    local.set $maxIteration

    (block $while
      (loop $whileBody
        ;; (x*x) + (y*y) <= 2
        local.get $x
        local.get $x
        f64.mul
        local.get $y
        local.get $y
        f64.mul
        f64.add
        f64.const 2
        f64.le
        
        ;; iteration < maxIteration
        local.get $iteration
        local.get $maxIteration
        i32.lt_u

        ;; this is the && operator; if both numbers are unsigned 1,
        ;; the result will be still an unsigned 1. this can be used
        ;; for the jump later on.
        i32.and
        
        i32.const 0
        i32.eq
        br_if $while

        ;; let xTemp = x*x - y*y + scaledX;
        local.get $x
        local.get $x
        f64.mul
        local.get $y
        local.get $y
        f64.mul
        f64.sub
        local.get $scaledX
        f64.add
        local.set $xTemp

        ;; y = 2*x*y + scaledY;
        f64.const 2
        local.get $x
        local.get $y
        f64.mul
        f64.mul
        local.get $scaledY
        f64.add
        local.set $y

        ;; x = xTemp;
        local.get $xTemp
        local.set $x

        ;; iteration += 1;
        local.get $iteration
        i32.const 1
        i32.add
        local.set $iteration

        br $whileBody
      )
    )

    local.get $iteration
  )
  (export "scaleToRange" (func $scaleToRange))
  (export "mandelbrot" (func $mandelbrot))
  (export "calculateIterations" (func $calculateIterations))
  (export "memory" (memory $memory))
)