import "@typespec/rest";
import "@typespec/versioning";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";
import "@typespec/rest";

using TypeSpec.Reflection;
using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.Core.Traits;

@service({
    title: "Azure Batch",
})
@versioned(Azure.Batch.Versions)
@doc("Azure Batch provides Cloud-scale job scheduling and compute management.")
namespace Azure.Batch;

@doc("The Azure Batch service version.")
enum Versions {
    @doc("API Version 2023-05-01.17.0")
    @useDependency(Azure.Core.Versions.v1_0_Preview_2)
    `2023-05-01.17.0`,
}

interface Ops {
    @post
    PostOperation<TResource, TResponse> is RpcOperation<
        BatchClientRequestHeaders & TResource,
        BatchResponseHeaders & TResponse,
        NoFilter,
        BatchError
    >;
}

alias NoFilter = {};

interface Pools {

    @summary("Cancels a failed deletion of a Certificate from the specified Account.")
    @doc("doc")
    @route("/certificates(thumbprintAlgorithm={thumbprintAlgorithm},thumbprint={thumbprint})/canceldelete")
    cancelCertificateDeletion is Ops.PostOperation<
        {
            @doc("The algorithm used to derive the thumbprint parameter. This must be sha1.")
            @path
            thumbprintAlgorithm: string;

            @doc("The thumbprint of the Certificate being deleted.")
            @path
            thumbprint: string;
        },
        {
            @doc("A process exit code.")
            @statusCode
            code: "204";
        }
    >;
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "The names of Model types must use camelCase"
@doc("Client related response header values")
model BatchRequestHeaders {
    @doc("""
    An OData $filter clause. For more information on constructing this filter, see
    https://docs.microsoft.com/en-us/rest/api/batchservice/odata-filters-in-batch#list-pools.
    """)
    @query
    $filter?: string;

    @doc("An OData $select clause.")
    @query({
        format: "csv",
    })
    $select?: string[];

    @doc("An OData $expand clause.")
    @query({
        format: "csv",
    })
    $expand?: string[];
}

#suppress "@azure-tools/typespec-azure-core/casing-style" "The names of Model types must use camelCase"
@doc("Client related response header values")
model BatchResponseHeaders {
    @doc("The client-request-id provided by the client during the request. This will be returned only if the return-client-request-id parameter was set to true.")
    @header
    `client-request-id`?: string;

    @doc("A unique identifier for the request that was made to the Batch service. If a request is consistently failing and you have verified that the request is properly formulated, you may use this value to report the error to Microsoft. In your report, include the value of this request ID, the approximate time that the request was made, the Batch Account against which the request was made, and the region that Account resides in.")
    @header
    `request-id`?: string;

    @doc("The ETag HTTP response header. This is an opaque string. You can use it to detect whether the resource has changed between requests. In particular, you can pass the ETag to one of the If-Modified-Since, If-Unmodified-Since, If-Match or If-None-Match headers.")
    @header
    @projectedName("python", "etag")
    ETag?: string;

    @doc("The time at which the resource was last modified.")
    @header
    @encode(DateTimeKnownEncoding.rfc7231)
    `Last-Modified`?: utcDateTime;
}

alias BatchClientRequestHeaders = {
    @doc("""
  Sets the maximum time that the server can spend processing the request,
  in seconds. The default is 30 seconds.
  """)
    @query
    @projectedName("client", "timeOutInSeconds")
    timeOut?: int32 = 30;
};

@doc("An error response received from the Azure Batch service.")
@error
model BatchError {
    @doc("An identifier for the error. Codes are invariant and are intended to be consumed programmatically.")
    code: string;

    @doc("A message describing the error, intended to be suitable for display in a user interface.")
    message?: ErrorMessage;

    @doc("A collection of key-value pairs containing additional details about the error.")
    values?: BatchErrorDetail[];
}

@doc("An error message received in an Azure Batch error response.")
model ErrorMessage {
    @doc("The language code of the error message.")
    lang?: string;

    @doc("The text of the message.")
    value?: string;
}

@doc("An item of additional information included in an Azure Batch error response.")
model BatchErrorDetail {
    @doc("An identifier specifying the meaning of the Value property.")
    key?: string;

    @doc("The additional information included with the error response.")
    value?: string;
}
