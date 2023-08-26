(module
  (memory $memory 1)
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
  (export "mandelbrot" (func $mandelbrot))
  (export "memory" (memory $memory))
)