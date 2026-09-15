class EventsController < ActionController::Base
  # BAD: remote input captured by a block is interpolated into raw SQL
  # executed inside an ActiveRecord `connected_to` role-switch block.
  def date_range_report
    lower_bound = params[:lower_bound]
    upper_bound = params[:upper_bound]

    ApplicationRecord.connected_to(role: :reading) do
      ApplicationRecord.connection.execute(
        "SELECT * FROM events WHERE start_time BETWEEN '#{lower_bound}' AND '#{upper_bound}'"
      )
    end
  end

  # BAD: same pattern with a single captured bound
  def since_report
    lower_bound = params[:lower_bound]

    ApplicationRecord.connected_to(role: :reading) do
      ApplicationRecord.connection.execute("SELECT * FROM events WHERE created_at > '#{lower_bound}'")
    end
  end

  # BAD: value read inside the block is assigned to an outer-scope variable,
  # then interpolated into SQL executed after the block returns.
  def deferred_report
    lower_bound = params[:lower_bound]
    captured = nil

    ApplicationRecord.connected_to(role: :reading) do
      captured = lower_bound
    end

    sql = "SELECT * FROM events WHERE created_at > '#{captured}'"
    ApplicationRecord.connection.execute(sql)
  end
end
