=begin

Algorithm Overview:

Given i) a set of items, each of which has a value and a weight, and ii) a maximum capacity (maximum possible weight),
maximize the value of items that can be taken.
 
if counter is 0, create a column where all values all 0, for length k
else
if counter is 1, look at array[1]
   go down each row, if the weight (array[1][1]) is greater than k, don't add the value
   otherwise, if the weight is equal to k, add the value if the value is greater than the value to the left (the cell value = the item value)    
  if k is greater than the weight, sum the value with the value in column to the left, k - weight
    and if that value is greater than the value to the left, add the value

after the table is created, look at the bottom right cell. if the value is greater than the value to the left,
we took the item (represented by 1), otherwise we didnt take the item (represented by 0)
if we took the item, look at the cell in the column to the left of k-weight
if the value to the left is the same, we didnt take the item. move to the left
return the added_items

=end
class Knapsack
  
  def initialize item_array
    @item_array = item_array
    splice_n_k
    create_table
  end
  
  def splice_n_k
    @num_items = @item_array[0][0]
    @k_capacity = @item_array[0][1]
  end
  
  

# k (capacity) = rows, n+1 (items + col0) = cols
  def create_table 
    @grid = []
    @k_capacity.times do |row| 
      @grid << []
      (@num_items+1).times {|col| @grid[row] << 0 }
    end
  end
  
  def populate_table
    (@num_items+1).times do |col|
      unless col == 0
        value = @item_array[col][0]
        weight = @item_array[col][1]
        @k_capacity.times do |row|
          if should_we_add_item? value, weight, row, col
            add_item value, weight, row, col
          else
            dont_add_item row, col
          end
        end
      end
    end
  end      
        
  def should_we_add_item? value, weight, row, col
    return false if weight > row+1
    return true if (weight == row+1) && (value > @grid[row][col-1])
    return true if (weight < row+1) && (value + @grid[row-weight][col-1] > @grid[row][col-1])
  end
    
  def dont_add_item row, col  
    @grid[row][col] = @grid[row][col-1]
    puts "grid row: #{row}, #{col} is: #{@grid[row][col]}"
  end
  
  def add_item value, weight, row, col
    if weight == (row + 1)
      @grid[row][col] = value
      puts "grid row: #{row}, #{col} is: #{@grid[row][col]}"
    elsif weight < (row + 1)
      temp_row = row - weight
      @grid[row][col] = value + @grid[temp_row][col-1]
      puts "grid row: #{row}, #{col} is: #{@grid[row][col]}"
    else
      puts "something went wrong in add_item. the value is neither = nor < than row+1"
    end 
  end
 
  def print_table
    @grid.each do |row|
      @grid[row].each do |col|
        puts "row: #{row}, col: #{col}, value: #{@grid[row][col]}"
      end
    end
  end

  def find_added_items
    @added_items = []
    temp_capacity = @k_capacity
    item_number = @num_items
    row = -1
    col = -1
    while temp_capacity > 0
      puts "looking at row #{row}, col #{col}, value #{@grid[row][col]}"
      if @grid[row][col] > @grid[row][col-1]
        @added_items << item_number
        row -= @item_array[item_number][1]
        puts "item #{item_number} was added"
      else
        puts "item #{item_number} was not added"
      end
      col -= 1
      puts "item_array val: #{@item_array[item_number][1]}"
      temp_capacity -= @item_array[item_number][1]
      item_number -= 1
    end
    puts "Knapsack contains items #{@added_items}"
  end
      
        



end

#arr = [[5,15],[5,5],[12,8],[1,3],[4,7],[7,4]] 
arr = [[4,11],[8,4],[10,5],[15,8],[4,3]]
k = Knapsack.new arr
k.populate_table
k.find_added_items




