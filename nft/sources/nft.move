module nft::loyalty_card {
    
    use sui::package::{Self};
    use std::string::{String};

    // Admin capability to guard access restricted methods
    public struct AdminCap has key, store {
        id: UID
    }

    public struct Loyalty has key, store {
        id: UID,
        customer_id: address,
        image_url: String
    }

    // One time witness to create the publisher
    public struct LOYALTY_CARD has drop {}

    // Called upon contract deployment
    fun init(otw: LOYALTY_CARD, ctx: &mut TxContext) {
        package::claim_and_keep(otw, ctx);
        let admin_cap = AdminCap { id: object::new(ctx) };
        transfer::public_transfer(admin_cap, tx_context::sender(ctx));
    }

    // Mint a new Loyalty card - requires admin capability
    public fun mint_loyalty(
        _: &AdminCap, 
        customer_id: address, 
        image_url: String, 
        ctx: &mut TxContext
    ) {
        let loyalty = Loyalty {
            id: object::new(ctx),
            customer_id,
            image_url
        };

        transfer::transfer(loyalty, customer_id);
    }
}