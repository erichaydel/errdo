module Errdo
  module HistogramHelper
    def hist(data, num_bins, time_start, time_range)
      times = {}
      (0..num_bins).each do |num|
        bin_start = (time_start + ((num.to_f / num_bins.to_f) * time_range))
        bin_end =   (time_start + (((num + 1) / num_bins.to_f) * time_range)).beginning_of_hour
        bin_start = bin_start.beginning_of_hour
        times[bin_start.strftime("%m/%d %I%p")] = data.select { |d| (d.created_at > bin_start) && (d.created_at <= bin_end) }.count
      end
      return times
    end

    def useful_time(time)
      if time < 1.day
        1.day
      elsif time < 1.week
        1.week
      else
        2.weeks
      end
    end
  end
end
