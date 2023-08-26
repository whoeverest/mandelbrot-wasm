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

    i32.const 0
    i32.const 100
    i32.store

    i32.const 4
    i32.const 200
    i32.store

    i32.const 8
    i32.const 300
    i32.store

    ;; return
    i32.const 42
  )
  (export "mandelbrot" (func $mandelbrot))
  (export "memory" (memory $memory))
)