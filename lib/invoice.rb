class Invoice
  def show_result(value, deadline)
    result = {
      :value => ("%.2f" % value),
      :deadline => deadline
    }

    t = (deadline - Date.today).to_i
    if value > 0
      if t < 5
        result[:status] = "warning"
      elsif t < 1
        result[:status] = "danger"
      end
    end

    result
  end
end
