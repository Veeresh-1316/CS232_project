# Memory/Cache Optimization for Graph Analytics

We experimented around with various cache hierarchies (namely: non-inclusive, inclusive, exclusive), with a few tweaks here and there, and came to very interesting
conclusions regarding how they affect a running program.
In addition to this, we also compared the effect and efficiency of numerous LLC cache replacement policies like LRU, LFU, DRRIP, and SHIP, and analysed their impact
on certain Graph workloads such as Page Rank(PR), Breadth First Search(BFS) and Single-Source-Shortest-Path(SSSP) algorithms.

We have created 3 Champsim folders containing the 3 policies implemented.  and they can be run with any traces.


# Hierarchy effects

Non-Inclusive :- This is the original implementation of the hierarchy in champsim

Exclusive :- We made LLC exclusive of L1 and L2C for this. The steps taken for this were:
  1. Any memory fetch from the RAM bypasses the LLC 
  2. Any eviction from L2C is invalidated in L1 and inserted into LLC regardless of the fact it is dirty or not
  3. Any read hit on LLC is sent to upper layer and consequently invalidated in LLC

Inclusive :- We made LLC inclusive of L1 and L2 and L2 inclusive of L1. The steps taken were:
  1. Any entry evicted from LLC is invalidated in both L1 and L2 of all cores if found.
  2. Any entry evicted in L2 is invalidated in L1 if found and writeback packet is sent to queue of LLC.

# The Hierarchy Effect

The following table captures the best cache hierarchy policies, and their improvement over standard non-inclusive hierarchy, for the different Graph Workload
algorithms that we analyzed, under the use of LRU (Least Recently Used) LLC replacement policy:

| Algorithm | Best Hierarchy | % improvement |
| :-----: | :-----: | :-----: |
| PR   | exclusive | 4 |
| BFS  | exclusive | 0.3 |
| SSSP | exclusive | 2 |

The exclusive policy is observed to be the better one albeit by a very small amount. The possible reason for this could the fact that memory accesses are random and 
exclusive policy allows you to accomodate more addresses and hence a handful of addresses which were fetched long ago are retained in exclusive but not in inclusive 
and hence their fetching from the cache instead of the RAM improves the exclusive by a couple percentage points. There is no concrete evidence that any trace is 
considerably better than other.

# Effect of changing the cache sizes

In the course of our experiment, we worked with LLC cache sizes of 2MB, 4MB, 8MB, 16MB and L2C cache sizes of 512KB, 1024KB and shockinlgy, increasing cache sizes
for either of the caches impacts negatively or negligibly. This is a consequence of the fact that graphing algorithms access memory very randomly and hence the distance 
between temporally near memory addresses is very high which these caches are unable to accomodate and hence the miss ratio is very high for both L2C and LLC. Hence decreasing 
their size improves the IPC since that decreases the latency too so latency comes out as a dominating factor here.
