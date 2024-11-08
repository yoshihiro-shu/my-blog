---
title: "Nuxtのvuex-persistedstateをSSRで使ってみる"
date: 2022-12-04T12:00:00+09:00
weight: 1
tags: ["cookie", "Vue.js", "Vuex", "ssr", "Nuxt"]
categories: ["frontend"]
---

{{% blocks/section color="white" %}}

## 背景

NuxtのSSRを行うライフサイクルにて`vuex-persistedstate`によるvuexのデータの更新が行えなかったことが今回のつまずき、解決するのにかなり時間を要したので記事にしました。

## 前提

vuexの短所としてリロードをするとstoreのデータが消えてしまうため、`vuex-persistedstate`を用いてcookieに保存していました。
しかし、asyncDataなどのSSRのライフサイクルにおいて、vuexの更新はSPA(CSR)側のcookieに反映されず、
結果としてvuexの更新がなされない問題が生じておりました。
vue-persistedstateに関しては、[こちら](https://github.com/robinvdvleuten/vuex-persistedstate#api)を参考にしてください

## 実装方法（サンプルコード）

色々探してみたところ、こちらの[issue](https://github.com/robinvdvleuten/vuex-persistedstate/issues/130#issuecomment-653723343)で解決されており、[cookie-universal-nuxt](https://github.com/microcipcip/cookie-universal/tree/master/packages/cookie-universal-nuxt#readme
)を使うとSSRでもvuexの更新が行えるとのことでした。

### cookie-universal-nuxtをインストールする

以下のコマンドでcookie-universal-nuxtをインストールしてください

```zsh
# npmの場合こちら
npm i --save cookie-universal-nuxt
# yarnの場合こちら
yarn add cookie-universal
```

#### 設定を追加する

moduleを扱うためにnuxt.config.jsに追加する

```nuxt.config.js
{
  modules: [
    // 追加
    'cookie-universal-nuxt',
 ]
}
```

#### pluginを実装する

moduleに追加すると、勝手に`$cookies`として[inject](https://nuxtjs.org/docs/directory-structure/plugins/#inject-in-root--context)されます。

```nuxt.config.js
{
  plugins: [
    // 追加
    '~/plugins/persistedstate.js'
  ],
}
```

```plugins/persistedstate.js
import createPersistedState from 'vuex-persistedstate';
export default ({store, app}) => {
    // ...
    createPersistedState({
        storage: {
            getItem: (key) => app.$cookies.getAll()[key],
            setItem: (key, value) => app.$cookies.set(key, value, { path: '/', maxAge: 60 * 60 * 24 * 7, secure: true }),//　7日間保持
            removeItem: (key) => app.$cookies.remove(key),
        }
    })(store)
}
```

## 動作の例

以下のようにするとSSR時にもstoreが更新されます。

```pages/mypage.vue
// ログイン必須のページ
<script>
  export default {
    async asyncData({ store }) {
    .....
        if (!store.token) {
            const { data } = await login(this.input);
            this.$store.commit('setToken', data.token);
        }
    .....
    }
  }
</script>
```

こちらの情報が誰かに役立てれば幸いです！

## 参考

- [vuex-persistedstate](https://github.com/robinvdvleuten/vuex-persistedstate#api)について

- [cookie-universal-nuxt](https://github.com/microcipcip/cookie-universal/tree/master/packages/cookie-universal-nuxt#readme)について

- 参考になった[issue](https://github.com/robinvdvleuten/vuex-persistedstate/issues/130#issuecomment-653723343)

{{% /blocks/section %}}
