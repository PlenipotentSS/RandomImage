require 'chunky_png'

def make_image(size, cluster, filename)
  png = ChunkyPNG::Image.new(size, size, ChunkyPNG::Color.rgba(255, 255, 255, 128))
  hex = "%06x" % (rand * 0xffffff)
  randomColor = ChunkyPNG::Color.from_hex(hex)

  values = []
  (size*size/2).to_i.times do |option|
    values.push(option % 2 == 0)
  end

  (size/cluster).to_i.times do |n|
    row = n*cluster
    (size/cluster/2).times do |m|
      col = m*cluster
      display = values.sample

      if display 
        cluster.times do |j|
          cluster.times do |k|
            values.delete_at(values.index(display) || values.length)
            png = add_pixel(png, row, col, j, k, size, randomColor)
          end
        end
      end
    end
  end
  png.save("dist/#{filename}.png", :interlace => true)
end

def add_pixel(png, row, col, row_add, col_add, size, color)
  inverseCol = size-1-col
  png[row+row_add,inverseCol] = color
  png[row,inverseCol-col_add] = color
  png[row+row_add,inverseCol-col_add] = color

  png[row+row_add, col] = color
  png[row, col+col_add] = color
  png[row+row_add, col+col_add] = color

  png
end


10.times do |i|
  make_image(120, 12, "filename-#{i}");
end