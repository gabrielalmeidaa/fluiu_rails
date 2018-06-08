class InvoicesController < ApplicationController
  include InvoicesHelper
  skip_before_action :verify_authenticity_token, :only => [:add_monthly_accounting_info]

  def accounting_info
    @user = current_user
    @accounting_info = AccountingInfo.new()
  end

  def add_monthly_accounting_info
    a = AccountingInfo.new(canceled_invoices: params[:accounting_info][:canceled_invoices],
      paycheck_changes: params[:accounting_info][:paycheck_changes],
      month: Time.now.strftime('%Y-%m'), user_id: current_user.id)
    a.financial_spreadsheet = params[:accounting_info][:financial_spreadsheet]
    a.save

    if params[:attachment] != nil
      params[:attachment][:files].each do |file|
        create_invoice ({user_id: current_user.id, file: file})
      end
    end

    redirect_to "/home"
    flash[:success] = "Operação Efetuada com Sucesso!"
    # return
  end

  ## POST /get_invoices/user_id
  ## Sends a ZIP document to requester containing invoices of param month for param user.
  def get_user_invoices
    user = User.find(params[:id])

    @zip_file = InvoicesService.zip_invoice_files user
    if @zip_file
      send_data(@zip_file[:data], :type => 'application/zip', :filename => @zip_file[:filename])
      flash[:success] = 'Arquivo enviado com sucesso!'
      return
    else
      flash[:error] = 'Algum erro ocorreu. XMLs não válidos foram encontrados.'
      return
    end

  end

  def create_invoice(invoice_params)
    invoice = Invoice.new(user_id: invoice_params[:user_id])
    invoice.invoice_file = invoice_params[:file]

    if invoice.save
      invoice.update_month_field
    end
  end

  def individual_report
    @invoice = Invoice.find(params[:id])
  end

  def monthly_invoices
    @month = params[:month]
  end

  def monthly_invoices_by_type
    @invoices = InvoicesService.group_invoice_by_entry_type(params[:id], params[:month], params[:type])
    if params[:filter] == 'dif_origin'
      @invoices = @invoices.reject {|invoice| Invoice.is_a_local_invoice?(invoice.invoice_file.read) == true }
    end
  end

end
