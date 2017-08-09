files_path = File.expand_path("../files", __dir__)

def io(file, mode = "r:utf-8")
  fd = IO.sysopen(file, mode)
  IO.new(fd, mode: mode)
end

def uniform_rows?(file_path)
  headers = nil
  File.open(file_path).each do |l|
    fields = l.split("\t")
    headers = fields unless headers
    return false if fields.size != headers.size
  end
  true
end

FILES = {
  all_fields: "#{files_path}/all-fields-semicolon.csv",
  all_fields_tiny: "#{files_path}/all-fields-tiny.csv",
  all_caps: "#{files_path}/all-caps.csv",
  sciname: "#{files_path}/simple-comma.csv",
  sciname_auth: "#{files_path}/authorship-tab.csv",
  sciname_rank: "#{files_path}/taxon-rank-tab.csv",
  single_field: "#{files_path}/single-field.csv",
  spaces_in_fields: "#{files_path}/spaces-in-fields.csv",
  no_taxonid: "#{files_path}/no-taxonid.csv",
  no_name: "#{files_path}/no-name.csv",
  fix_headers: "#{files_path}/fix-headers.csv",
  csv_relaxed: "#{files_path}/csv-relaxed.csv",
  output: "/tmp/output.csv"
}.freeze
