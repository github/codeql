class EventsController < ActionController::Base
  # BAD: remote input captured by a block is interpolated into raw SQL
  # executed inside an ActiveRecord `connected_to` role-switch block.
  def date_range_report
    lower_bound = params[:lower_bound] # $ Source
    upper_bound = params[:upper_bound] # $ Source

    ApplicationRecord.connected_to(role: :reading) do
      ApplicationRecord.connection.execute(
        "SELECT * FROM events WHERE start_time BETWEEN '#{lower_bound}' AND '#{upper_bound}'" # $ Alert
      )
    end
  end

  # BAD: same pattern with a single captured bound
  def since_report
    lower_bound = params[:lower_bound] # $ Source

    ApplicationRecord.connected_to(role: :reading) do
      ApplicationRecord.connection.execute("SELECT * FROM events WHERE created_at > '#{lower_bound}'") # $ Alert
    end
  end

  # BAD: value read inside the block is assigned to an outer-scope variable,
  # then interpolated into SQL executed after the block returns.
  def deferred_report
    lower_bound = params[:lower_bound] # $ Source
    captured = nil

    ApplicationRecord.connected_to(role: :reading) do
      captured = lower_bound
    end

    sql = "SELECT * FROM events WHERE created_at > '#{captured}'"
    ApplicationRecord.connection.execute(sql) # $ Alert
  end
end
