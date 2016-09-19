require 'csv'
class Network
  def self.check_ip_and_return_device(address)
    csv_text = File.read(ENV['IPALLOC_DATAPATH'])
    csv = CSV.parse(csv_text)
    ip_device = nil
    csv.each_with_index do |row, index|
      next if index == 0
      if row[1].strip == address
        ip_device = row[2]
        break
      end
    end
    ip_device
  end

  def self.insert_data_into_csv(address, device)
    csv_text = File.read(ENV['IPALLOC_DATAPATH'])
    csv = CSV.parse(csv_text)
    csv << ['1.2.0.0/16', address, device]
    CSV.open(ENV['IPALLOC_DATAPATH'], "w") do |insert_csv|
      csv.each do |row|
        insert_csv << row
      end
    end
  end
end