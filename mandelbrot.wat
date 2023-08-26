(module
  (memory 1)
  (func $mandelbrot
    (param $width i32)
    (param $height i32)
    (param $xMin f32)
    (param $xMax f32)
    (param $yMin f32)
    (param $yMax f32)

    (result i32)
    
    i32.const 42
  )
  (export "mandelbrot" (func $mandelbrot))
)