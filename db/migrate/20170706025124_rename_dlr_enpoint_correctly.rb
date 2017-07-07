class RenameDlrEnpointCorrectly < ActiveRecord::Migration[5.1]
  def change
    rename_column :short_code_services, :dlr_enpoint, :dlr_endpoint
  end
end
