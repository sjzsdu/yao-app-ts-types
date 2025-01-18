export namespace YaoRest {
  // REST The RESTFul API
  export interface RestDSL {
    /**版本【管理字段】 */
    version?: string;
    /**描述【管理字段】 */
    decription?: string;
    /**备注【管理字段】 */
    comment?: string;
    /**API 呈现名称 */
    name?: string;
    // group?: string;
    /**描述*/
    description?: string;
    /**API 全局中间件，多个用 "," 分割。除特别声明，组内所有 API 都将使用全局中间件
     *
     * 常用bearer-jwt
     */
    guard?: string;
    /**API 列表。具体查看 `Object Path` 数据结构*/
    paths?: Path[];
    $schema?: string;
  }

  // Path The RESTFul API Route path
  export interface Path {
    /**标签 */
    label?: string;
    /**描述 */
    description?: string;
    /**API 路由名称。完整路由地址为 `/api/<group>/<path>` ，变量使用 `:` 声明，如 `/api/user/find/:id`, 可以使用 `$param.id` 访问路由请求参数*/
    path: string;
    /**请求类型。许可值 `GET`、`POST`、`PUT`、`DELETE`、 `HEAD`、`OPTIONS`、`Any`. 其中 `Any` 将响应任何类型的请求*/
    method: string;
    /**调用处理器 `process`*/
    process: string;
    /**API 中间件. 如不设置，默认使用全局中间件。如不希望使用全局中间件，可将数值设置为 `-` 。|
     *
     * 常用bearer-jwt
     */
    guard?: string;
    /**请求参数表，将作为 `process` 的输入参数(`args`)。可以引用传入参数，可以为空数组 [查看输入参数](#输入参数)*/
    in?: any[];
    /**请求响应结果定义。 具体查看 `Object Out` 数据结构*/
    out?: Out;
  }

  // Out The RESTFul API output
  export interface Out {
    /**请求响应状态码*/
    status: number;
    /**请求响应 Content Type*/
    type?: string;
    /**请求响应 Headers */
    headers?: { [key: string]: string };
  }

  // Option the server option
  // export interface Option {
  //   mode?: string; // the server mode production / development
  //   root?: string; // the root route path of the RESTFul API server
  // }
}
