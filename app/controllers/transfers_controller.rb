class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :update, :destroy]

  # GET /transfers
  def index
    @transfers = Transfer.all

    render json: @transfers
  end


  # POST /transfers
  def create
    firebaseurl = 'https://transfernabil.firebaseio.com/'
    dbsecret = 'reot8keY1FhuhhMUKAprkBXs2tyRrTm6gLcbJEM0'
    firebase = Firebase::Client.new(firebaseurl, dbsecret)
    @transfer = Transfer.new(transfer_params)
    @transfer.with_lock do
     if @transfer.save
      response = firebase.push("Backup transfer", { :nama_pengirim => @transfer.nama_pengirim,:no_rek => @transfer.no_rek,:nama_penerima => @transfer.nama_penerima, :keterangan => @transfer.keterangan,:nominal => @transfer.nominal, :waktuBuat => @transfer.created_at, :waktuUpdate => @transfer.updated_at})
      render json: @transfer, status: :created
    else
      render json: @transfer.errors, status: :unprocessable_entity
    end
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transfer_params
      params.require(:transfer).permit(:nama_pengirim, :nama_penerima, :no_rek, :nominal, :keterangan)
    end
end
