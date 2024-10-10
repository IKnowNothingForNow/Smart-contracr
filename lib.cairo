use core::starknet::ContractAddress;

#[starknet::interface]
pub trait IBookstore<TContractState> {
    fn add_books(
        ref self: TContractState,
        book_id: felt252,
        title: felt252,
        name_of_author: felt252,
        publisher: felt252,
        publication_date: felt252,
        isbn: u64,
        edition: u64,
        genre: felt252,
        quantity: u32
    );
    fn remove_books(ref self: TContractState, book_id: felt252);
    fn borrow_books(ref self: TContractState, book_id: felt252);
    fn order_books(ref self: TContractState, book_id: felt252, order_details: felt252);
    fn get_total_number_of_books(self: @TContractState) -> u128;
    fn get_orders(self: @TContractState, order_details: felt252) -> u256;
    fn get_book(self: @TContractState, book_details: felt252) -> u256;
}

#[starknet::contract]
mod Bookstore {
    use starknet::get_caller_address;
    use core::starknet::Storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
}
#[storage]
struct Storage {
    bookstore: Map::<felt252, Book>, //which u64...meant to be the book_id
    book_count: felt252,
    bookstore_owner: ContractAddress,
    total_number_of_books: felt252,
    order_details: felt252,
    book_details: felt252,
}


#[constructor]
fn constructor(ref self: ContractState, bookstore_owner: ContractAddress) {
    self.bookstore_owner.write(bookstore_owner);
}


#[derive(Drop, Serde, starknet::Store)]
struct Book {
    book_id: felt252,
    title: felt252,
    name_of_author: felt252,
    publisher: felt252,
    publication_date: felt252,
    isbn: u64,
    edition: u64,
    genre: felt252,
    quantity: u32,
}

#[event]
#[derive(Drop, starknet::Event)]
enum event {
    TransactionDetails: TransactionDetails,
    OrderConfirmation: OrderConfirmation,
    DeliveryUpdates: DeliveryUpdates,
    BookBorrowed: BookBorrowed,
}


#[derive(Drop, starknet::Event)]
struct TransactionDetails {
    #[key]
    transaction_id: felt252,
    amount: u256,
    timestamp: u64,
}

#[derive(Drop, starknet::Event)]
struct OrderConfirmation {
    #[key]
    order_id: felt252,
    customer: ContractAddress,
    total_amount: u256,
}

#[derive(Drop, starknet::Event)]
struct DeliveryUpdates {
    #[key]
    tracking_number: felt252,
    status: felt252,
    estimated_delivery: u64,
}

#[derive(Drop, starknet::Event)]
struct BookBorrowed {
    #[key]
    book_id: felt252,
    borrower: ContractAddress,
    due_date: u64,
}

#[abi(embed_V0)]
impl BookstoreImpl of super::IBookstore<ContractState> {
    fn add_books(
        ref self: TContractState,
        book_id: felt252,
        title: felt252,
        name_of_author: felt252,
        publisher: felt252,
        publication_date: felt252,
        isbn: u64,
        edition: u64,
        genre: felt252,
        quantity: u32
    ) {
        let new_book = Book {
            book_id,
            title,
            name_of_author,
            publisher,
            publication_date,
            isbn,
            edition,
            genre,
            quantity
        };
        self.bookstore.write(book_id, new_book);
    }

    fn remove_books(ref self: TContractState, book_id: felt252) {
        let mut bookstore = self.bookstore.read();
        bookstore.remove(book_id);
        self.bookstore.write(books);
    }

    fn borrow_books(ref self: TContractState, book_id: felt252) {
        let mut bookstore = self.bookstore.read();
        bookstore.borrow(book_id);
        self.bookstore.write(books);

        self.emit(BookBorrowed { book_id: book_id, borrower: starknet::get_caller_address(), });
    }

    fn order_books(ref self: TContractState, book_id: felt252, order_details: felt252) {
        assert(book_exists(book_id), 'Book does not exist');
        process_order(book_id, order_details);
        // self.emit
    }

    fn get_total_number_of_books(self: @TContractState, total_number_of_books: felt252) -> felt252 {
        let total_books = self.total_number_of_books.read();
        total
        books
    }

    fn get_orders(self: @TContractState, order_details: felt252) -> felt252 {
        let orders = self.order_details.read();
        orders
    }

    fn get_book(self: @TContractState, book_details: felt252) -> felt252 {
        let book = self.book_details.read();
        book
    }
}

