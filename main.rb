require 'roo'

# =======
def get_user_input(text)
  user_input = ''
  while user_input.empty?
    puts text
    user_input = $stdin.gets.chomp
  end
  user_input
end

def get_file_name
  puts get_user_input("Input filename for converting with file extension")
end

def get_number_barcodes_for_grouping
  number = nil
  until number.to_i > 0
    number = get_user_input("Input the number of barcodes to group")
    puts "number            #{number}"
    puts "number.to_i > 0   #{number.to_i > 0}"
  end
end

# =======
def read_barcodes_from_file(file_name)
  barcodes = []
  begin
    xlsx = Roo::Spreadsheet.open(file_name)
    xlsx.each { |rows|  barcodes += rows.compact }
    xlsx.close
  rescue Exception => e
    puts "An error occurred while reading: #{e}"
    exit
  end
  # удалить "код набора (новый код)", "код еденицы товара (коды которые обьединяются)"
  barcodes.drop(2)
end

# =======
# # User inputs
file_name = get_file_name
number_for_grouping = get_number_barcodes_for_grouping

file = File.join("#{__dir__}", 'вход.xlsx')
if File.exist?(file)
  puts "Start converting file #{file}"
  barcodes = read_barcodes_from_file('вход.xlsx').map { |barcode| "\"#{barcode.gsub('"', '""')}\"" }
  p barcodes
  puts "End converting file #{file}"
else
  puts 'File not exist'
end
