
class Book
  attr_reader :author, :title, :year_published, :edition
  attr_accessor :id, :status, :borrower, :reviews

  def initialize(title, author, year_published = nil, edition = nil)
    @title = title
    @author = author
    @id = nil
    @status = "available"
    @year_published ||= year_published
    @edition ||= edition
    @reviews = []
  end

  def check_out(borrower)
    if @status == "available"
       puts "checked out book"
       @status = "checked_out"
       @borrower = borrower
       @borrower.num_checked_out += 1
       true
      else
        @status = "checked_out"
        puts "this book is already checked out"
        false
    end
  end

  def check_in
    if @status == "checked_out"
      puts "checked in book"
      @status = "available"
      @borrower.num_checked_out -= 1
      @borrower = nil
      did_it_work = true
    else
      @status = "available"
      puts "this book isn't checked out"
      did_it_work = false
    end
  end

  def review(borrower, rating, text = nil)
    @borrower = borrower
    @rating = rating
    @text ||= text
    @reviews << {:borrower => @borrower.name, :title => @title, :rating => @rating, :text => @text}
  end

end

class Borrower
  attr_accessor :num_checked_out
  attr_reader :name

  def initialize(name)
    @name = name
    @num_checked_out = 0
  end

end

class Library
  attr_reader :name, :books

  def initialize(name)
    @books = []
    @id_counter = 100
  end

  def books
    @books
  end

  def count
    @books.count
  end


  def register_new_book(title, author)
    new_book = Book.new(title, author)
    @books << new_book
    new_book.id = @id_counter
    @id_counter += 1
  end

  # @param [Object] id
  def check_out_book(book_id, borrower)
    # use book_id to find the book_title
    # detect returns first object, not the array (as select does)
    if borrower.num_checked_out < 2
      checked_out_book = @books.detect { |x| x.id == book_id  }
      if checked_out_book.status == "available"
        checked_out_book.check_out(borrower)
        checked_out_book
      end
    end
  end

  def check_in_book(book)
    book.check_in
  end

  def available_books
    @books.select { |book| book.status == "available"}

  end

  def borrowed_books
     @books.select { |book| book.status == "checked_out"}
  end

  def get_borrower(book_id)
    checked_out_book = @books.detect { |x| x.id == book_id  }
    checked_out_book.borrower.name
  end

end
