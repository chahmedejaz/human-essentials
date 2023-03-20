module Exports
  class ExportProductDrivesCSVService
    extend ItemsHelper
    HEADERS = ["Product Drive Name", "Start Date", "End Date", "Held Virtually?", "Quantity of Items", "Variety of Items", "In Kind Value"]

    def self.generate_csv(product_drives, organization)
      CSV.generate do |csv|
        csv << generate_headers(organization)

        product_drives.each do |drive|
          csv << generate_row(drive)
        end
      end
    end

    class << self
      private

      def generate_row(drive)
        [
          drive.name.to_s,
          drive.start_date.strftime("%m-%d-%Y").to_s,
          drive.end_date&.strftime("%m-%d-%Y").to_s,
          (drive.virtual ? "Yes" : "No").to_s,
          drive.donation_quantity.to_s,
          drive.distinct_items_count.to_s,
          dollar_value(drive.in_kind_value).to_s,
          *drive.items_quantity_by_name
        ]
      end

      def generate_headers(organization)
        HEADERS + organization.items.order(:name).pluck(:name)
      end
    end
  end
end
