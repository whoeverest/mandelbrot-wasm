;; https://developer.mozilla.org/en-US/docs/WebAssembly/Reference

(module
  (memory $memory 1)

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
    (param $xMin f32)
    (param $xMax f32)
    (param $yMin f32)
    (param $yMax f32)

    (result i32)

    (local $i i32)

    (loop $my_loop
      local.get $i ;; offset
      i32.const 100
      i32.store

      ;; i += 4
      local.get $i
      i32.const 4
      i32.add
      local.set $i

      local.get $i
      i32.const 100
      i32.lt_u ;; less than, unsigned
      br_if $my_loop
    )

    i32.const 42
  )
  (export "scaleToRange" (func $scaleToRange))
  (export "mandelbrot" (func $mandelbrot))
  (export "memory" (memory $memory))
)