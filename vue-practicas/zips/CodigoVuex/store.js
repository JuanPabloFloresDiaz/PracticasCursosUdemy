import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    msg: 'Vuex desde Cero.',
    nombre: 'Grover',
    apellido: 'Vásquez',
    amigos: []       
  },
  mutations: {
    addAmigo( state, amigo ) {
      state.amigos = [amigo,...state.amigos]
    },
    delAmigo( state, index ) {
      state.amigos.splice( index, 1 );
    }
  },
  actions: {
    addAmigoAction( context, amigo ) {
      context.commit('addAmigo', amigo);
    },
    delAmigoAction( context, index ) {
      context.commit( 'delAmigo', index );
    } 
  },
  getters: {
    mensaje( state ) {
      return state.msg;
    },
    nombreCompleto( state ) {
      return `${state.nombre} ${state.apellido}`
    } 
  }
})
