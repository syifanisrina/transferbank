class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.string :nama_pengirim
      t.string :nama_penerima
      t.string :no_rek
      t.string :nominal
      t.text :keterangan

      t.timestamps
    end
  end
end
