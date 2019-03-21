class SalesController < ApplicationController
  def new
    @sale = Sale.new
  end

  def create
    sale = Sale.new(sale_params)
    sale[:tax] = 19 unless sale[:tax].zero?
    sale[:total] = sale[:value] - sale[:value] * sale[:discount] / 100
    sale[:total] += sale[:total] * sale[:tax] / 100
    sale[:cod] = Sale.all.count.zero? ? 1 : Sale.order(:cod).last[:cod] + 1
    if sale.save
      redirect_to sales_done_path, notice: 'El registro fue almacenado con éxito!'
    else
      redirect_to root_path, alert: 'Ha ocurrido un error, intténtelo de nuevo'
    end
  end

  def done
    @sale = Sale.last
  end

  private

  def sale_params
    params.require(:sale).permit(:detail, :category, :value, :discount, :tax)
  end
end
