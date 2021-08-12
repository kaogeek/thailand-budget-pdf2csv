#! /usr/bin/env ruby -w

require "csv"

csv_table = CSV.open('full_budget.csv', headers: true).read
csv_table.by_col.delete(0)
csv_table.delete('debug_log')
csv_table.by_col['amount'] = csv_table.by_col['amount'].map { |a| a.gsub(/,/, "") }

File.write("full_budget_db_ready.csv", csv_table.to_csv)
