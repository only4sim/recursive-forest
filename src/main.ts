import { Pickles } from 'o1js/dist/node/snarky.js';
import { Add } from './Add.js';
import {
  Field,
  Mina,
  PrivateKey,
  AccountUpdate,
  SelfProof,
  ZkProgram,
  Struct,
  Bool,
  Circuit,
  Poseidon,
  MerkleMap,
  MerkleTree,
  MerkleWitness,
  MerkleMapWitness,
  verify,
  Provable,
} from 'o1js';
import { dummyBase64Proof } from 'o1js/dist/node/lib/proof_system.js';
import { provable } from 'o1js/dist/node/bindings/lib/provable-bigint.js';


async function main() {
  
    console.log('o1js loaded');
  
    console.log('compiling...');


    let state = Field(0);
    const a = [Field(0), Field(0), Field(0), Field(0), Field(0), Field(6), Field(7), Field(8), Field(9), Field(10), Field(11), Field(12), Field(13), Field(14), Field(15)];
    const b = [Field(1), Field(2), Field(3), Field(4), Field(5), Field(6), Field(7)];
  
    const { verificationKey } = await Predicate.compile();
  
    console.log('making proof 0')
  
    const proof0 = await Predicate.init(state);
  
    console.log('making proof 1')
  
    const proof1 = await Predicate.predict(state, proof0, a, b);
    console.log('making proof 2')
  
    const proof2 = await Predicate.predict(state, proof1, a, b);

    console.log('verifying proof 2');
    console.log('proof 2 data', proof2.publicInput.toString());
  
    const ok = await verify(proof2.toJSON(), verificationKey);

    console.log('ok', ok);

    // state = dtp(state, a, b);
    // console.log('state 1: ', state.toString());
    // state = dtp(state, a, b);
    // console.log('state 2 ', state.toString());
  
    console.log('Shutting down');
  
}

const Predicate = ZkProgram({
    name: 'predicate',
    publicInput: Field,

    methods: {
        init: {
            privateInputs: [],
            
            method(state: Field) {
                state.assertEquals(Field(0));
            }
        },
        predict: {
            privateInputs: [SelfProof, Provable.Array(Field, 15), Provable.Array(Field, 7)],
            
            method(state: Field, earlierProof: SelfProof<Field, void>, a: Field[], b: Field[]) {
                earlierProof.verify();
                state.add(Provable.if(a[0].lessThan(b[0]), 
                Provable.if(a[1].lessThan(b[1]),
                    Provable.if(a[3].lessThan(b[3]), a[7], a[8]), 
                    Provable.if(a[4].lessThan(b[4]), a[9], a[10])),
                Provable.if(a[2].lessThan(b[2]),
                    Provable.if(a[5].lessThan(b[5]), a[11], a[12]), 
                    Provable.if(a[6].lessThan(b[6]), a[13], a[14]))
                ));
            }
        },
    },

})

export function dtp(state: Field, a: Field[], b: Field[]):Field {
    return state.add(Provable.if(a[0].lessThan(b[0]), 
    Provable.if(a[1].lessThan(b[1]),
        Provable.if(a[3].lessThan(b[3]), a[7], a[8]), 
        Provable.if(a[4].lessThan(b[4]), a[9], a[10])),
    Provable.if(a[2].lessThan(b[2]),
        Provable.if(a[5].lessThan(b[3]), a[11], a[12]), 
        Provable.if(a[6].lessThan(b[3]), a[13], a[14]))
    ));
}
main();