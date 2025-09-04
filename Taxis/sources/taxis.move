module taxis::taxis {
    use std::string::{String};
    use sui::vec_map::{VecMap, Self};

    public struct BaseTaxis has key, store {
        id: UID,
        nombre_base: String,
        telefono_contacto: String,
        taxis: VecMap<u8, Taxi>,
        id_taxi: u8,
    }

    public struct Taxi has store, drop {
        nombre_taxista: String,
        disponible: bool,
    }  

    #[error]
    const TAXI_NO_EXISTE: vector<u8> = b"El id del taxi no es valido o no existe";

    public fun crear_base_taxis(ctx: &mut TxContext, nombre_base: String, telefono: String) {
    let base = BaseTaxis {
        id: object::new(ctx),
        nombre_base,
        telefono_contacto: telefono,
        taxis: vec_map::empty(),
        id_taxi: 0u8
    };

    transfer::transfer(base, tx_context::sender(ctx))
    }

    public fun crear_taxi(base: &mut BaseTaxis, nombre: String, disponible: bool) {
        let taxi = Taxi {
            nombre_taxista: nombre,
            disponible,
        };
        let id = base.id_taxi + 1;
        base.id_taxi = id;
        base.taxis.insert(id, taxi);

    }   


    public fun modificar_estado_taxi(base: &mut BaseTaxis, id: u8, nuevo_estado: bool) {
        assert!(base.taxis.contains(&id), TAXI_NO_EXISTE); // Asegura que el taxi existe

        let taxi_ref = base.taxis.get_mut(&id);
        taxi_ref.disponible = nuevo_estado;
    }

    public fun eliminar_taxi(base: &mut BaseTaxis, id: u8) {
        assert!(base.taxis.contains(&id), TAXI_NO_EXISTE); // Asegura que el taxi existe
        base.taxis.remove(&id);
    }
}
