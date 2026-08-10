require "test_helper"

class NoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "belongs to a client" do 
    firm = Firm.create!(name: "Accounting Test")

    client = firm.clients.create!(
      name: "Acme Corp",
      company_name: "Acme Corporation",
      status: "active"
    )

    note = client.notes.create!(content: "Discussion of taxes for Q4")

    assert_equal client, note.client
  end

  test "client can have many notes" do 
    firm = Firm.create!(name: "Accounting Test")

    client = firm.clients.create!(
      name: "Acme Corp",
      company_name: "Acme Corporation",
      status: "active"
    )
    note1 = client.notes.create!(content: "Discussion of taxes for Q4")
    note2 = client.notes.create!(content: "Discussion of taxes for Q3")

    assert_includes client.notes, note1
    assert_includes client.notes, note2
    assert_equal client.notes.count, 2
  end
end
